From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4.37] iptables: handle IPT_RETURN from user target
Date: Wed, 18 Mar 2009 16:24:27 +0100
Message-ID: <49C1122B.3030508@trash.net>
References: <49C0F7ED.40106@expand.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: haimdaniel@gmail.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49C0F7ED.40106@expand.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Haim Daniel wrote:
> This patch handles IPT_RETURN retcode for user's iptables' targets 
> (modules).
> 
> Up until now it was handled only for the built-in RETURN iptables' target
> and IPT_RETURN in a user target resulted in a NF_DROP.

And what module will be using this?
