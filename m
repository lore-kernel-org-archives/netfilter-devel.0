From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nftables] Git location for User space utilities
Date: Mon, 25 Mar 2013 09:10:40 +0200
Message-ID: <514FF870.1010401@linux.intel.com>
References: <CACd6PL04YMafbQb6uV6OKZJWrD_jJe3DZmin9oGmhBbdx6Wgcw@mail.gmail.com> <CACd6PL1G_ELCNe1EnF7jR9fVGVCjFcKb0Cwcx_y6oP5EVFf9Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Vidya Chowdary <vidya.chowdary@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3CYHKn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:10:43 -0400
In-Reply-To: <CACd6PL1G_ELCNe1EnF7jR9fVGVCjFcKb0Cwcx_y6oP5EVFf9Fg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

>   http://1984.lsi.us.es/git/nftables/
> git://git.netfilter.org/libnl-nft.git
> git://git.netfilter.org/nftables.git
>
> Please confirm if above location remains intact or should I fork from some
> other git repository for user space and libnl enhancements.

These are the right one indeed.

There is also a repository for a backward compatible tool with iptables: 
http://1984.lsi.us.es/git/iptables-nftables/
and the necessary library: http://1984.lsi.us.es/git/libnftables/

The most complete implementation against nftables is nft tool anyway

Tomasz
