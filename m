From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: Building ipset-6.24 on CentOS7 fails
Date: Tue, 16 Dec 2014 23:34:56 +0100
Message-ID: <5490B390.9030105@redhat.com>
References: <CADuigkUASKDzmaHZmiLWLXadS_u13rnXV8+ww+UygYVaiD=RYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaLPWfB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:35:01 -0500
In-Reply-To: <CADuigkUASKDzmaHZmiLWLXadS_u13rnXV8+ww+UygYVaiD=RYw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/16/2014 08:18 PM, Ricardo Klein wrote:
> Trying to build ipset 6.24 on CentOS7 fails... Here is the error:
> http://pastebin.com/LDMvs0rv
>
> **ipset-6.23 works.

That's because CentOS7 is missing commit:

commit 93be3c2eb3371f022ad88acf1ab6bee8e3c38378
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Nov 12 15:10:03 2013 -0800

     list: introduce list_last_entry(), use list_{first,last}_entry()

You could work around that by manually adding this to your kernel
source in order to build that.
