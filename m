From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Sun, 22 Jan 2012 18:41:40 +0100
Message-ID: <20120122174140.GA18764@1984>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52788 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab2AVRlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jan 2012 12:41:46 -0500
Content-Disposition: inline
In-Reply-To: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Quentin,

On Sat, Jan 21, 2012 at 08:52:17AM -0500, Quentin Aebischer wrote:
> Edit : I first sent to user list, sorry about that :x.
> 
> Hi everyone,
> 
> I've implemented a very basic TIPC channel for the conntrackd daemon.
> 
> You can pull from here : git@github.com:Vauteck/Conntrack-tools.git master

Thanks for sharing this with us. I cannot access your tree, I need the
public way to clone it for read-only, you have sent the access to your
tree read-write via SSH, this is wrong.

However:

It would great if you can send us your contribution in the form of one
patch, which is the standard way to do things in FOSS projects.

http://lxr.linux.no/#linux+v3.2.1/Documentation/SubmittingPatches
https://git.wiki.kernel.org/articles/g/i/t/GitSvnCrashCourse_512d.html

We can review the changes you made in my email client, that saves me
time and makes my life way easier! ;-)
