From: "Eble, Dan" <DanE@aiinet.com>
Subject: libipt_mac.c: minor bug and questions
Date: Fri, 6 Sep 2002 14:21:20 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <638AA0336D7ED411928700D0B7B0D75B03053C7E@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yesterday I began evaluating iptables for MAC and IP address ACLs.  It looks
like it will work very well, but I think there is a bug at libipt_mac.c:121.
It says printf("--mac ") instead of printf("--mac-source ").  Please forgive
me if I am a clueless newbie, but this seem like a bad thing.

Also, has anyone considered adding a mask option to the MAC matcher?  If
not, I will probably do it.  Is the preferred syntax "--mac-source
<address>/<mask>" where zero bits in the mask cause the matcher to ignore
the corresponding bits in the address?  That seems to agree with what I have
seen in other places.

Finally, are there any problems with using "install" in the Makefile instead
of "cp"?  "cp" doesn't work well with the build process my company uses, so
I have had to edit the Makefile.  It is not a huge problem, but I would much
rather use an unmodified distribution than have to maintain differences.

Please reply to dane@aiinet.com, as I don't have time to read all the list
mail.
Thanks in advance.

-- 
Dan Eble <dane@aiinet.com>           _____  .
Applied Innovation Inc.             |  _  |/|
Dublin, OH  43017-3271              | |_| | |
614-923-1185 or 800-247-9482 x2051  |__/|_|_|
