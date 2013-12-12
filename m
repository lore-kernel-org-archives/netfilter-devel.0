From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftables PATCH 2/2] table: Add support for NFTA_TABLE_USE
 nftables attribute
Date: Thu, 12 Dec 2013 15:10:37 +0200
Message-ID: <52A9B5CD.6090800@linux.intel.com>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1386853244-16783-4-git-send-email-tomasz.bursztyka@linux.intel.com> <CAOkSjBjOCcfthVBjt90P0NKx--L-0zzMRijeVe_J7xapmn_19w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55761 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab3LLNKk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:10:40 -0500
In-Reply-To: <CAOkSjBjOCcfthVBjt90P0NKx--L-0zzMRijeVe_J7xapmn_19w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> +                       "<flags>%d</flags><use%d</use></table>",
> small typo: <use>%d</use>

Indeed

Thanks Arturo

Tomasz

