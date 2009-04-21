From: "Matthew L. Creech" <mlcreech@gmail.com>
Subject: Re: Build breakage in 1.4.3
Date: Tue, 21 Apr 2009 19:06:57 -0400
Message-ID: <5ee96a840904211606n69ccbac3s956bad857ec05136@mail.gmail.com>
References: <5ee96a840904211350ofc00f91r98491da19638edf0@mail.gmail.com>
	 <alpine.LSU.2.00.0904220046170.20050@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:3024 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZDUXG6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:06:58 -0400
Received: by yx-out-2324.google.com with SMTP id 3so1281131yxj.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2009 16:06:57 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0904220046170.20050@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 21, 2009 at 6:46 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> Which cross combination is this please?
>

powerpc-linux-gnu, using CodeSourcery's toolchain (4.3-50).  I also
just tried an arm-none-linux-gnueabi cross-compile and got the same
result.

I've configured with "--prefix=/ --host=powerpc-linux-gnu", then I'm
setting DESTDIR to my real prefix for "make install", in case that
makes a difference.

-- 
Matthew L. Creech
