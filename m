From: Daniel Drake <dsd@gentoo.org>
Subject: Re: 2.6.12 netfilter: local packets marked as invalid
Date: Fri, 08 Jul 2005 17:12:20 +0100
Message-ID: <42CEA5E4.40009@gentoo.org>
References: <42CE86B5.2080705@gentoo.org> <42CE8E96.1040905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262694AbVGHQLa@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42CE8E96.1040905@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> You could confirm this theory by logging invalid packets in LOCAL_OUT
> and in PRE_ROUTING - only PRE_ROUTING should trigger. I'm going to
> think about a solution meanwhile.

You'll have to forgive my lack of netfilter knowledge, I set up my firewall
ages ago and haven't really touched it since :)

How can I do this with iptables?

Thanks,
Daniel
