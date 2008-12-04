From: "James King" <t.james.king@gmail.com>
Subject: Re: L2 NAT
Date: Wed, 3 Dec 2008 17:01:20 -0800
Message-ID: <38bcb3ec0812031701k3df95b38y5bf4c77686a2347f@mail.gmail.com>
References: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: ivan <lagigliaivan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:10619 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbYLDBBW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:01:22 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3594709ugf.37
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2008 17:01:20 -0800 (PST)
In-Reply-To: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 3, 2008 at 9:22 AM, ivan <lagigliaivan@gmail.com> wrote:
> I would like to pass parameters to the kernel module in run time from
> user space. These parameters could be IP address and MAC. Somebody
> know how I can do this??

Use the module_param functions (you probably want the string variant).
 See http://tldp.org/LDP/lkmpg/2.6/html/x323.html for examples.

> I was thinking about passing this parameters thorough a sysctl syscall
> or using /proc filesystem, but I beleave that this is not the correct
> way.

Depends on if you need to be able to modify it after the module has
already been loaded.  If not, a module parameter should suffice.


HTH,
James
