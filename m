From: Jeff Klesky <netfilter@allycomm.com>
Subject: How to contribute to documentation?
Date: Sat, 19 Aug 2017 15:22:47 -0700
Message-ID: <686ff7c0-d6f6-4e93-3ba2-65e1190fdec3@wagsky.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.allycomm.com ([138.68.30.55]:46621 "EHLO mx.allycomm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdHSWcl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 18:32:41 -0400
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First off, let me say that coming from a background of Cisco and 
FreeBSD-based firewalls, nftables is a welcome discovery!

I've been trying to figure out both the logic and the syntax and have 
been stymied by the lack of complete and/or consistent documentation.  
I've read the man page for nft, both from Ubuntu 16.04.3 LTS and online, 
as well as gone through https://wiki.nftables.org/ a few times and still 
can't find the information I need to be able either to create a 
non-trivial firewall using nftables, or to have the confidence that it 
will perform as expected.

In the hopes that what I learn along the way can help other end users 
and the project in the future, what are the best ways to contribute to 
the documentation?

Also, where can I get the "formal" syntax description for the nft commands?

Even just knowing what is required and what is optional would help 
immensely and allow me to determine if it is a "bug" or if it is my 
error.  As an example, I apparently wrongly assumed that declaring a set 
and adding elements to it in the context of a table declaration would 
default to using that table for the set. Unfortunately, "read the 
source" isn't an option as I work on projects that are not 
license-compatible with the terms of GPL.

Hopefully I can figure out what isn't present in kernel 4.9 through the 
release notes (such as fib access, though it is not noted as such on the 
wiki).

Thanks!

Jeff Kletsky


Distributor ID:  Ubuntu
Description:     Ubuntu 16.04.3 LTS
Release:         16.04
Codename:        xenial

Kernel: 4.9.28-38

