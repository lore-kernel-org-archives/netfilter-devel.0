From: "Sebastien Tricaud" <stricaud@inl.fr>
Subject: [ANNOUNCE] Wolfotrack 1.0 released
Date: Mon, 28 Apr 2008 16:06:48 +0200 (CEST)
Message-ID: <58500.192.168.33.142.1209391608.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:54764 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbYD1OGv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:06:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tears were flowing from our bellowed
Administrators out there.

Connection tracking is not always easy,
hence Wolfotrack, the conntrack killer that
aims to reduce the firewall use difficulty
that many people complained about for years.
This software makes this time gone! We are now
enhancing netfilter at the user level.

    \o\ \o| |o| \o/ /o/
    \o\ THERE IT IS /o/
    \o\ |o| |o/ /o/ /o/


The long...

and awaited...

Netfilter connection tracking killer!


The great Wolfotrack, based on our favorite game
Wolfenstein 3d!

You simply kill people that are tight to a state
updated by the connection tracking.

Everytime a door is opened, this table is refreshed.

And when the actor is killed, the connection tracking
associated is killed as well!


Wall of Quotes
==============

"With wolfotrack, I look forward new connections. Banning p2p has never been
so fun !"
    -- Pascal Terjan, Mandriva kernel team

"Obviously the most significant new firewall GUI for productivity
increases and stopping real time attacks, since X-Window came out...
the best way for firewall admins to understand what's going on, track
it down, and kill it."
    -- Dragos Ruiu, (Can|Eu|Pac)Sec(West|) organizer

"Wolfotrack is the synthesis of the tremendous INL's experience on firewall GUI.
It overruns all existing interfaces by providing amazing productivity increase
for firewall administrator"
    -- Eric Leblond, NuFW author and INL co-founder

"Wolfotrack is the most comprehensive, cutting edge, visionary tool for
slaying evil guys connections as they come through, in real time, before
they can harm you for good."
    -- Cedric Blancher, Computer Security Researcher


Wolfotrack project
==================

Youtube demo video: http://www.youtube.com/watch?v=z3zRnHPFPrc
Project Page: http://software.inl.fr/trac/wiki/Wolfotrack


Get it!
=======
Tarball:
http://software.inl.fr/releases/wolfotrack/wolfotrack-1.0.tar.gz

Shareware data files, with Nazi symbols replaced by 'nupiks':
http://www.wallinfire.net/files/wolf3d-data_nupik-shareware.tar.gz

The original shareware data files can be retrieved from:
ftp://ftp.3drealms.com/share/1wolf14.zip
(and rename .WL1 files into lower case)


Some history
============

People know how efficient psdoom is, and we needed something
similar to manipulate Netfilter connection states for customers.

Unfortunately, psdoom was too 'bling-bling' and may be hard to
manipulate the connection states because of weapons like BFG9000.

That is why Wolfenstein 3d was a natural choice.


Developers
==========

Sebastien Tricaud
Victor Stinner
Laurent Defert


Build
=====
cmake .
make


Run
===

$ sudo ./sdlwolf3d x3

Yes, it has to be runned as root ;-), and x3 will make the display bigger.


Known Issues
============
* Demo mode: Beware, the demo mode will actually kill your connections for
real. Make sure you are awake and ready :)
* x86_64: Simply does not work on this architecture. The program segfaults at
startup.


