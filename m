From: Morgon.J.Kanter@Dartmouth.edu
Subject: Re: Recalculate checksums in netfilter queue
Date: Thu, 22 Apr 2010 08:43:13 -0400
Message-ID: <20100422084313.jk0ntlfyss444g0o@webmail.dartmouth.edu>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
	<x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
	<z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from spruis.dartmouth.edu ([129.170.208.37]:39786 "EHLO
	spruis.dartmouth.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab0DVM7n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:59:43 -0400
In-Reply-To: <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


  My understanding is that the one complement of each 16-bit word is
> summed, and then the result of that is bitwise complemented.
>
> So for each word we would do something like this.
> for each word{
>      sum += ~word;
> }
>
> then you would take the bitwise complement of that total.
> sum = ~sum;

The RFC for IP contains C code that you can literally copy and paste  
for this task.

-- Morgon
