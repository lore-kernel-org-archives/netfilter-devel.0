Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61503C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EBC92080A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfFLSDE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:03:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfFLSDD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:03:03 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4DB2230C3187;
        Wed, 12 Jun 2019 18:03:03 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-253.rdu2.redhat.com [10.10.121.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 841571001B1C;
        Wed, 12 Jun 2019 18:03:01 +0000 (UTC)
Date:   Wed, 12 Jun 2019 14:02:59 -0400
From:   Eric Garver <eric@garver.life>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v1] iptables-test: fix python3
Message-ID: <20190612180259.hnuy4eewzpfugfip@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        shekhar sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
References: <20190606195058.4411-1-shekhar250198@gmail.com>
 <20190611185909.lxxmgw5zbmqgq2ek@egarver.localdomain>
 <CAN9XX2qUAYXer1fmi1ksiiu1LC-WjtiTJ3xGBqKF2B+7OAv_9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2qUAYXer1fmi1ksiiu1LC-WjtiTJ3xGBqKF2B+7OAv_9Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 12 Jun 2019 18:03:03 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 01:36:42PM +0530, shekhar sharma wrote:
> On Wed, Jun 12, 2019 at 12:29 AM Eric Garver <eric@garver.life> wrote:
> >
> > On Fri, Jun 07, 2019 at 01:20:58AM +0530, Shekhar Sharma wrote:
> > > This patch converts the 'iptables-test.py' file (iptables/iptables-test.py) to run on
> > > both python 2 and python3.
> > >
> > >
> > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > ---
> > >  iptables-test.py | 43 ++++++++++++++++++++++---------------------
> > >  1 file changed, 22 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/On Sun, Jun 09, 2019 at 11:48:49PM +0530, Shekhar Sharma wrote:
> > This patch adds the netns feature to the 'nft-test.py' file.
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The version history of the patch is :
> > v1: add the netns feature
> > v2: use format() method to simplify print statements.
> > v3: updated the shebang
> > v4: resent the same with small changes
> >
> >  tests/py/nft-test.py | 98 ++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 80 insertions(+), 18 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 4e18ae54..c9f65dc5 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> [..]
> iptables-test.py b/iptables-test.py
> > > index 532dee7..8018b65 100755
> > > --- a/iptables-test.py
> > > +++ b/iptables-test.py
> > [..]
> > > @@ -79,7 +80,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
> > >
> > >      cmd = iptables + " -A " + rule
> > >      if netns:
> > > -            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + cmd
> > > +            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + "  {}".format(cmd)
> >
> > This is a bogus change. No reason to switch to format() when we're just
> > concatenating strings. Many occurrences of this in the patch.
> >
> > I think you only need to fix the print statements.
> >
> 
> Okay, i will change it and resend the patch.
> > >
> > >      ret = execute_cmd(cmd, filename, lineno)
> > >
> > [..]
> > > @@ -365,9 +366,9 @@ def main():
> > >              passed += file_passed
> > >              test_files += 1
> > >
> > > -    print ("%d test files, %d unit tests, %d passed" %
> > > -           (test_files, tests, passed))
> > > +    print("{} test files, {} unit tests, {} passed".format(test_files, tests, passed))
> > >
> > >
> > >  if __name__ == '__main__':
> > >      main()
> > > +
> >
> > Bogus new line.
> 
> Should i change the shebang to this here as well?
> #!/usr/bin/env python

Yes. Might as well since you already have to reroll the patch.
