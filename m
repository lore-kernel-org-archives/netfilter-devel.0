From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Permit *any* destination port from source ip
Date: Mon, 19 Jan 2009 21:34:13 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901192131570.12940@fbirervta.pbzchgretzou.qr>
References: <C59A4C44.D285%simon@clubbeadplus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Simon Labrecque <simon@clubbeadplus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58838 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZASUeO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:34:14 -0500
In-Reply-To: <C59A4C44.D285%simon@clubbeadplus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-19 21:27, Simon Labrecque wrote:
>On 19/01/09 3:14 PM, "Jan Engelhardt" <jengelh@medozas.de> wrote:
>> On Monday 2009-01-19 21:11, Simon Labrecque wrote:
>
>If there's no way to flag a connection as RELATED for any
>destination port (given a known source and destination IP), then I
>guess I'll have no choice, but I'm still not sure if it's possible
>or not (beside the fact that this wouldn't be a *best practice*).

The conntrack(8) tool allows you to set up expectations and so on
from userspace.
