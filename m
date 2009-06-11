From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: does NAT based on iptables support TCP hole punch?
Date: Wed, 10 Jun 2009 21:57:31 -0700
Message-ID: <20090610215731.694c3661@nehalam>
References: <69b8237b0906102042q647797bdl88e16be088af6f45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tony Wan <visual2me@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:38900 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZFKE5e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:57:34 -0400
In-Reply-To: <69b8237b0906102042q647797bdl88e16be088af6f45@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 11 Jun 2009 11:42:44 +0800
Tony Wan <visual2me@gmail.com> wrote:

> Hi all,
> 
> It's said that TCP hole punch does not work if both endpoints come
> from 2 sub-networks, whose NAT are both implemented by iptables. I
> just want to make sure whether this is true. If so, what type of nat
> can iptables work as? full-cone, restricted, port restricted, or
> symmetric?
> 
> Sorry if it's not appropriate to ask such a question here. Thanks in advance.

You might want to look up STUNT which uses an intermediary to open the NAT tunnel.
