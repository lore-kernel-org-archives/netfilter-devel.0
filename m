From: John Stultz <john.stultz@linaro.org>
Subject: [Regression?] iptables broken on 32bit with pre-4.7-rc
Date: Wed, 25 May 2016 22:52:38 -0700
Message-ID: <CALAqxLXgAA=zV_AAOTkWE3yFaxNJ02y0jGwVrdTW+rSCrSUMkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: lkml <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hey Florian, Pablo,

In updating a 32bit arm device from 4.6 to Linus' current HEAD, I
noticed I was having some trouble with networking, and realized that
/proc/net/ip_tables_names was suddenly empty.

Digging through the registration process, it seems we're catching on the:

       if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
           target_offset + sizeof(struct xt_standard_target) != next_offset)
               return -EINVAL;

check added in 7ed2abddd20cf ("netfilter: x_tables: check standard
target size too").

Where next_offset seems to be 4 bytes larger then the the offset +
standard_target struct size.

Commenting out those checks (the commit doesn't revert cleanly), seems
to get things going again for me.

I'm not exactly sure how the next_offset value is set, so I'm hoping
the proper fix is more obvious to one of you.

thanks
-john
