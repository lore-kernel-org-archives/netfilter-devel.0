From: David Miller <davem@davemloft.net>
Subject: Re: warnings in current tree
Date: Wed, 22 Apr 2009 02:27:22 -0700 (PDT)
Message-ID: <20090422.022722.82114710.davem@davemloft.net>
References: <20090421.014357.219275555.davem@davemloft.net>
	<20090421.014427.86938853.davem@davemloft.net>
	<49EDA5CE.4010108@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49EDA5CE.4010108@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 21 Apr 2009 12:54:06 +0200

> Hi David!
> 
> David Miller wrote:
>> From: David Miller <davem@davemloft.net>
>> Date: Tue, 21 Apr 2009 01:43:57 -0700 (PDT)
>> 
>> Sorry, duh, meant netfilter-devel :-)
>> 
>>> Can someone fix these up?  Thanks!
>>>
>>> net/netfilter/nf_conntrack_netlink.c:1234: warning: 'helpname' may be used uninitialized in this function
>>> net/netfilter/nf_conntrack_netlink.c:991: warning: 'helpname' may be used uninitialized in this function
> 
> Hm, weird, is this a "bogus punch"? I don't remember to have seen those
> here and that code has not been modified recently.
> 
> Anyway, patch attached :).

Applied, thanks :-)

The problem is when you pass the address of a local variable
to a function, which is then inlined and has non-trivial
control flow (as far as GCC is concerned), and this is the
way the variable is initialized.
