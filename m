From: Tihomir Katic <tihomir.katic@gmail.com>
Subject: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 15:18:38 +0200
Message-ID: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab1FINSj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:18:39 -0400
Received: by iwn34 with SMTP id 34so1288413iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 06:18:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I developed some firewall optimizer for iptables optimization.

FIRO is parsing output of iptables-save command and removes redundant
rules from it. Rules in each chain and table are optimized separately.
Optimization procedure continues until there are no more rules to
remove or to modify. As a result, FIRO generates new file with new set
of rules for every successful optimization procedure. Also, it logs
all actions and changes in separated files.

List of optimization procedures:
 -  Remove irrelevant rules
 -  Remove redundant "shadowed after" rules
 -  Remove redundant "shadowed before" rules
 -  Remove last rules with same action as chain
 -  Merge rules
 -  Remove redundant parameters from rules
 -  Remove redundant elements from parameters
 -  Reposition of "logging" rules in chain

This is free software, 1st published version, and I would appreciate
every download, every test, every reported bug, suggestion, etc.

Link to FIRO:
http://valeria.zesoi.fer.hr/~tkatic

Br
Tihomir
