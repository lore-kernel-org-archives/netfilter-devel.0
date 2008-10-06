From: "Tanneeru Muralidhar Babu-A19589" <muralidharbabu@motorola.com>
Subject: iptables execution with sudo fails
Date: Mon, 6 Oct 2008 12:56:33 +0800
Message-ID: <548BC174642DC44AB25D749C28840FD308C72D7F@ZMY16EXM66.ds.mot.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail119.messagelabs.com ([216.82.245.51]:55285 "HELO
	mail119.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750832AbYJFE4j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 00:56:39 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,
 
While executing iptables command using sudo on my system (running MV
2.6.10), I see following errors. Could someone please help me understand
this error ?
 
sudo:        0 : uid 0 does not exist in the passwd file! ; TTY=unknown
; PWD=unknown ; USER=root ; COMMAND=/sbin/iptables
 
Is this a problem with passwd file ? Under what circumstances do we see
this error ?
 
Thanks,
Murali
