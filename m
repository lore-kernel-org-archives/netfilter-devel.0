From: Simon Labrecque <simon@clubbeadplus.com>
Subject: Re: Permit *any* destination port from source ip
Date: Mon, 19 Jan 2009 16:26:53 -0500
Message-ID: <C59A5A4D.D28A%simon@clubbeadplus.com>
References: <alpine.LSU.2.00.0901192131570.12940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:39972 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZASV04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:26:56 -0500
Received: from simip10-ac.srvr.bell.ca ([206.47.199.89])
          by simmts5-srv.bellnexxia.net
          (InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP
          id <20090119212654.MTSF1658.simmts5-srv.bellnexxia.net@simip10-ac.srvr.bell.ca>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 19 Jan 2009 16:26:54 -0500
In-Reply-To: <alpine.LSU.2.00.0901192131570.12940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> On Monday 2009-01-19 21:27, Simon Labrecque wrote:
>> On 19/01/09 3:14 PM, "Jan Engelhardt" <jengelh@medozas.de> wrote:
>>> On Monday 2009-01-19 21:11, Simon Labrecque wrote:
>> 
>> If there's no way to flag a connection as RELATED for any
>> destination port (given a known source and destination IP), then I
>> guess I'll have no choice, but I'm still not sure if it's possible
>> or not (beside the fact that this wouldn't be a *best practice*).
> 
> The conntrack(8) tool allows you to set up expectations and so on
> from userspace.

Would maybe work, but then again this would require deployment of new
applications. Also, if it's possible to modify the expectations as needed
using conntrack-tools (haven't tried yet), I would expect it would be
possible to do it directly in the module... no?

Simon Labrecque

