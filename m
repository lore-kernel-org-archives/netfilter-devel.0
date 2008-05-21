From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Thu, 22 May 2008 00:01:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54039 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYEUWBv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 18:01:51 -0400
In-Reply-To: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-05-21 16:17, James Morris wrote:
>
>In a nutshell, the need for this arises from the fact that MAC labeling 
>rules utilizing iptables via SECMARK and CONNSECMARK are not subject to 
>discretionary security policy (i.e. not even "root" or a user with 
>CAP_NET_ADMIN may be able to modify these rules).

Yet I do not see any code to possibly prohibit changing the table.
