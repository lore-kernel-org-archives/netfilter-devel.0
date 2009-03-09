From: Fred Moyer <fred@redhotpenguin.com>
Subject: module testing practices [was Re: build error when compiling nfsim
	against 2.6.23.17]
Date: Mon, 9 Mar 2009 15:36:25 -0700
Message-ID: <ad28918e0903091536r6d35cbf7ncf9ac0e74ed6dffb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:59487 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCIWg1 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:36:27 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1870267rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Mar 2009 15:36:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 6, 2009 at 11:42 AM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Friday 2009-03-06 19:37, Fred Moyer wrote:
>>>>
>>>>What is the recommended alternative for testing connection helper m=
odules?
>>>
>>> Testing them in a real world - perhaps virtual machines though - se=
tup :-)
>>
>>I've had great success developing and testing with VMWare Fusion on a
>>mac laptop. =A0The reboot time on an oops is maybe two minutes, about
>>the same as my metal testing server, except lacking the fan noise and
>>ability to live on my laptop.
>
> At least VMware Workstation has the Snapshot feature which cuts the
> "reboot" time down to whatever it takes to reread the disk image from=
 disk.
>
> Avoiding oopses is the best strategy, at which point you can reedit-
> compile-reload the module as often as you need without reverting to
> a snapshot.

In the event of an oops, do you have any suggestions for capturing the
stacktrace?  My vmware terminal console is 25 rows with no scrollback
when it oopses, so I'm only getting half the stack.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
