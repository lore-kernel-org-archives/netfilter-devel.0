From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ipset website
Date: Sat, 29 Nov 2014 02:23:05 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr>
References: <547919CB.7030202@nospam.hostisimo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Wright <nobody@nospam.hostisimo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:48771 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaK2BXH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:23:07 -0500
In-Reply-To: <547919CB.7030202@nospam.hostisimo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2014-11-29 01:56, Mike Wright wrote:
>
> I've made some updates to the ipset.netfilter.org website.  The changes are
> cosmetic, such as highlighting the menu link when on a specific page,

The syntax for color= is probably incorrect, it is missing #.
But why do you even introduce the archaic <font> tag? The CSS
class "hot" seemed to be just right.

Forcing a scrollbar also seems backwards. If the table is to
have a consistent size irrespective of scrollbar, one would
probably use CSS's position: or float:.

> framing the man pages so that you don't have to use the "back" button to
> continue navigating the site (required adding four new pages).

It adds another scrollbar rather than just filling the page downards.
This would preferably call for something like SSI, or PHP's include(),
for avoiding the duplication of the menu.


> To see the diffs between the original pages and mine:
>
>    http://ipset.hostisimo.com/diffs

They are not in unified form.
