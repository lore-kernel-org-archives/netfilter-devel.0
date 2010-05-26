From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add nflog_snprintf_xml() to output a log in XML format
Date: Wed, 26 May 2010 15:10:35 +0200
Message-ID: <4BFD1DCB.1050509@netfilter.org>
References: <20100526123959.6039.31915.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53068 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab0EZNKq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 09:10:46 -0400
In-Reply-To: <20100526123959.6039.31915.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds a new function to output the packet in XML format.

I'm going to extend these to add NFLOG_XML_TIME. This patch will be used
by ulogd2's XML output plugin. Consider these patches preliminary
work-in-progress.
