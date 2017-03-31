From: Vikas <vikas.c.kumar@oracle.com>
Subject: Writing metadata to a packet
Date: Thu, 30 Mar 2017 22:16:18 -0700
Message-ID: <58DDE622.8070107@oracle.com>
References: <577C8ADD.60007@oracle.com> <1467793086.1273.12.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, eric@netfilter.org
To: coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41132 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932938AbdCaFQc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 01:16:32 -0400
In-Reply-To: <1467793086.1273.12.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I was wondering if how we can set some user specified values when we 
punt a packet from source to destination in a infrastructure which uses 
netfilter? More precisely at the source side so that when packet reaches 
destination host, it can decode the metadata values.
Is their a way out? Any pointer/link would be appreciated.

Regards
Vikas

