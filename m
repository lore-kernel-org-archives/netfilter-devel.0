From: Felipe Kellermann <stdfk@terra.com.br>
Subject: [PATCH/iptables] Duplicated matches/targets
Date: Wed, 2 Nov 2005 04:04:36 -0200 (BRST)
Message-ID: <Pine.BSO.4.62.0511020401470.32113@bepuvq.alien.bet>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1033900039-1130911476=:32113"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter - Devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1033900039-1130911476=:32113
Content-Type: TEXT/PLAIN; charset=US-ASCII

While doing little modifications in my extension list, I've accidently
built a binary (NO_SHARED_LIBS) with a duplicated match. I immediately
noticed this because with that duplicated match I couldn't "load" some
other matches of my list of matches (e.g., state).

% sort initext.c | uniq -d
        ipt_comment_init();
extern void ipt_comment_init(void);
% iptables -m state
iptables v1.3.4: Couldn't find match `state'
Try `iptables -h' or 'iptables --help' for more information.

With a trivial debugging I noticed that the iptables_match list was
leaking. find_match() is always returning NULL when loaded == 0 and
ipt_tryload == DONT_LOAD and NO_SHARED_LIBS is defined. Just setting
loaded to 1 when it's successfully "loaded" solved the problem.

Additionally, IMHO we shouldn't exit() while registering matches or
targets that are already registered. Doing that could prevent rules of
getting commited just because there are duplicated matches or targets.

Any objections to just skipping when the revisions are the same? The
current code already skips when the old revision is greater than "me".

% iptables -m state
iptables: match `comment' already registered.
iptables v1.3.4: You must specify `--state'
Try `iptables -h' or 'iptables --help' for more information.

-- 
Felipe Kellermann
--0-1033900039-1130911476=:32113
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=iptables-dup-felipek.diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.BSO.4.62.0511020404360.32113@bepuvq.alien.bet>
Content-Description: 
Content-Disposition: attachment; filename=iptables-dup-felipek.diff

SW5kZXg6IGlwdGFibGVzLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0t
LSBpcHRhYmxlcy5jCShyZXZpc2lvbiA0NDIwKQ0KKysrIGlwdGFibGVzLmMJ
KHdvcmtpbmcgY29weSkNCkBAIC0xMTIwLDcgKzExMjAsNyBAQA0KIAkJCWZw
cmludGYoc3RkZXJyLA0KIAkJCQkiJXM6IG1hdGNoIGAlcycgYWxyZWFkeSBy
ZWdpc3RlcmVkLlxuIiwNCiAJCQkJcHJvZ3JhbV9uYW1lLCBtZS0+bmFtZSk7
DQotCQkJZXhpdCgxKTsNCisJCQlyZXR1cm47DQogCQl9DQogDQogCQkvKiBO
b3cgd2UgaGF2ZSB0d28gKG9yIG1vcmUpIG9wdGlvbnMsIGNoZWNrIGNvbXBh
dGliaWxpdHkuICovDQpAQCAtMTE1MCw2ICsxMTUwLDcgQEANCiANCiAJbWUt
Pm0gPSBOVUxMOw0KIAltZS0+bWZsYWdzID0gMDsNCisJbWUtPmxvYWRlZCA9
IDE7DQogfQ0KIA0KIHZvaWQNCkBAIC0xMTc4LDcgKzExNzksNyBAQA0KIAkJ
CWZwcmludGYoc3RkZXJyLA0KIAkJCQkiJXM6IHRhcmdldCBgJXMnIGFscmVh
ZHkgcmVnaXN0ZXJlZC5cbiIsDQogCQkJCXByb2dyYW1fbmFtZSwgbWUtPm5h
bWUpOw0KLQkJCWV4aXQoMSk7DQorCQkJcmV0dXJuOw0KIAkJfQ0KIA0KIAkJ
LyogTm93IHdlIGhhdmUgdHdvIChvciBtb3JlKSBvcHRpb25zLCBjaGVjayBj
b21wYXRpYmlsaXR5LiAqLw0K

--0-1033900039-1130911476=:32113--
