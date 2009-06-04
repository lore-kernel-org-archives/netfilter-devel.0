From: Iwan Budi Kusnanto <iwanbk@gmail.com>
Subject: VLAN tagging not supported by ebtables ?
Date: Thu, 4 Jun 2009 17:30:37 +0700
Message-ID: <41f748550906040330l36d5b241w7b0d4d52db352a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: bdschuym@pandora.be
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58543 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZFDKha (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:37:30 -0400
Received: by pzk1 with SMTP id 1so9102pzk.33
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2009 03:37:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I'm new to ebtables. From my googling and looking into ebtables source
code, ebtables doesn't support vlan tagging ? Am i right ? ( i already
looked at ebt_vlan.c).

If yes, is there any reason why vlan tagging support in ebtables not
implemented by netfiler/ebtables developer ?

Thanks

-- 
Iwan Budi Kusnanto
