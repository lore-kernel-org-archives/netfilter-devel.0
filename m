From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Fwd: Re: Re: [PATCH 2.4.37] iptables: handle IPT_RETURN from
 user target]
Date: Wed, 18 Mar 2009 18:02:09 +0100
Message-ID: <49C12911.2080507@trash.net>
References: <49C12888.3000907@expand.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: haimdaniel@gmail.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49C12888.3000907@expand.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Haim Daniel wrote:
> Patric McHardy wrote:
> 
>  > And what module will be using this?
>  > --
> 
> Currently there's no such module in the src tree. I've encountered the 
> problem
> myself when I needed to write a proprietary module for the company I 
> work for.
> I've seen prev posts on the subject as well.

You'll have to carry this patch yourself. Until we need it for something
in the mainline tree, there's no reason to change it.
