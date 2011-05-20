From: Shruti Sanadhya <shruti.sanadhya@cc.gatech.edu>
Subject: Porting libnetfilter_queue to Android
Date: Fri, 20 May 2011 12:48:19 -0400
Message-ID: <BANLkTinoE8dbO7SPLgmcxMiGENNneU3wjg@mail.gmail.com>
References: <BANLkTimg283VEpFwjuwojTbCjQ-LWv_1YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from deliverator5.gatech.edu ([130.207.165.165]:45636 "EHLO
	deliverator5.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab1ETQsk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 12:48:40 -0400
Received: from deliverator5.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 1B39B18006E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2011 12:48:40 -0400 (EDT)
Received: from mail3.gatech.edu (mail3.gatech.edu [130.207.185.163])
	by deliverator5.gatech.edu (Postfix) with ESMTP id B31561800FB
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2011 12:48:39 -0400 (EDT)
Received: from mail-vw0-f46.google.com (mail-vw0-f46.google.com [209.85.212.46])
	(Authenticated sender: ssanadhya3)
	by mail3.gatech.edu (Postfix) with ESMTPSA id A476A149242
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2011 12:48:39 -0400 (EDT)
Received: by vws1 with SMTP id 1so2807805vws.19
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2011 09:48:39 -0700 (PDT)
In-Reply-To: <BANLkTimg283VEpFwjuwojTbCjQ-LWv_1YA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I have a working C code on Ubuntu 10.10 which uses libnetfilter_queue
to do some packet mangling. I would like to port this code to Android
platform. Though
http://benno.id.au/blog/2007/11/13/android-native-apps gives basic
guidelines for compiling a 'hello world' program, it does not support
libnetfilter_queue. If anybody has any experience in using
libnetfilter_queue on Android, or some other ARM platform, please
respond.

Thanks,
Shruti
