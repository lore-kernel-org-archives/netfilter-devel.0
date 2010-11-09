From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: balance traffic between virtual interfaces on the same network
Date: Tue, 9 Nov 2010 09:12:45 -0800
Message-ID: <20101109091245.47a7a5c3@nehalam>
References: <AANLkTi=bi5TkpZaN=af1YZZDDLt3P9H3k1s7mNk7xQAJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tommaso Calosi <tcalosi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:60701 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0KIRMr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:12:47 -0500
In-Reply-To: <AANLkTi=bi5TkpZaN=af1YZZDDLt3P9H3k1s7mNk7xQAJ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 9 Nov 2010 14:36:25 +0100
Tommaso Calosi <tcalosi@gmail.com> wrote:

> Hi all,
> 
> This is my setup:
> 
> eth0:1 192.168.1.10/24
> eth0:2 192.168.1.20/24
> eth0:3 192.168.1.30/24
> 
> gateway 192.168.1.1
> 
> I know it's a strange question but it's crucial to do this in my setup.
> I need to balance traffic between these virtual interfaces so that the
> gateway sees the traffic originating from 1.10, 1.20,  and 1.30. Is it
> possible

Virtual interfaces are a leftover BSD artifact. They do not have any
real state of their own. Virtual interfaces all map to the same underlying
network device object.  There is no reason to use them in Linux since
version 2.4.

Is the traffic originating locally on multiple sockets, or is it
being passed through?
