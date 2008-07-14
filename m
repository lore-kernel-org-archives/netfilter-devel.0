From: "Kevin Sookocheff" <kevin.sookocheff@gmail.com>
Subject: Invalid size of target
Date: Mon, 14 Jul 2008 15:26:31 -0400
Message-ID: <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17286 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbYGNT0d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:26:33 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1551681nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2008 12:26:32 -0700 (PDT)
In-Reply-To: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I am having a problem developing an IPTables module.

I get the following error (CSUM is the name of my module):

ip_tables: CSUM target: invalid size 0 != 12

The first question is why this error appears, and why does it only
appear for SMP kernels?


Thank you,

Kevin Sookocheff
