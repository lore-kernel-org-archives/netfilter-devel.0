From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  00/15] Xtables extensions: full support (pure nft or compat layer)
Date: Fri, 19 Jul 2013 18:17:29 +0300
Message-ID: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GSPRt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:17:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

So here it is: my proposal for a full support of xtables extensions, bo=
th with compat layer (match/target expressions) and also with pure nft =
translation.
(Note that this is only an RFC, since currently: this works only on ipt=
ables-nftables built with --enable-static, you will see why.)


Summary
-------

I came up with an idea which required a lot of refactoring, mostly to s=
implify the code and of course to find a solution for all our problems =
with xtables extensions.

In short, now process it strictelly following these path:
injecting rules: command line -> command structure -> nft rule -> kerne=
l
reading rules  : kernel -> nft rule -> command structure -> listing/sav=
ing etc...

The big difference introduced in that patch is reusing the command stru=
cture in both ways, and not only for injecting rules.
Result: clearer code, only 1 parsing of the rule expressions is necessa=
ry (_that_ is a big change), and of course we can reuse easily existing=
 legacy code.


The nft translation process
---------------------------

Parsing the rule expressions is the key here.
Central place for it: the nft translation engine. This "engine" is a ba=
sic tree based pattern matching code.
In short: you register an "instruction" - made of a list of nft express=
ions - and a parsing function into a instructions tree.

=46or instance, one of the possible list of nft expressions for retriev=
ing the ip addresses part of a rule is: payload, bitwise, compare.
Thus you can provide such list and a related parsing function to the "i=
nstruction tree" and when you will give a rule to be translated through=
 the engine,
if such instructions list is found, it will call the relevant parsing f=
unction.

It of course handles the case where a pattern is made of other known sm=
aller patterns: so is the long pattern the one which matches, or the sm=
aller ones?
Such case is handled. The engine takes care of keeping track of all pat=
terns. The policy of "longest pattern found" is applied for deciding wh=
ich ones matches.
(It matches when the given parsing function returns a success code).

Now that we can express all parts of a rule via such "instructions", pa=
rsing function can populate the command structure.


The Xtables extensions
----------------------

Such translation engine has an interest for centralizing the parsing in=
to one object (the command structure), but even more for future port of=
 xtables extensions,
expressed as pure nft expressions.

Currently, nftables provides a compatibility layer to support xtables e=
xtensions as there current form: the infamouf memory blob.
But little by little, such memory blobs will be expressed as pure nft e=
xpressions list. The most obvious one was DNAT (and SNAT), thus I alrea=
dy implemented such support (last patch)

And there would start the troubles: about 100 of extensions, all expres=
sed in a small subset of nft expressions... go figure which expressions=
 list matches which extensions.
Morever that, on the contrary of current compatibility layer, the exten=
sion name is not going to be present at all.

Hopefully, the translation process described above applies perfectly he=
re and solves that issue as well.


Patches
-------

Now the code.

Please review,

Tomasz Bursztyka (15):
  xtables: Add support for injecting xtables target into nft rule
        -> If a target extensions provides a way to "translate" its blo=
b as pure nft expressions list, let's use it.
  xtables: add support for injecting xtables matches into nft rule
        -> same for matches extensions
  nft: Add nft expressions translation engine as a library
        -> Self explainatory. I made it af a library since both the cor=
e and the xtalbse extensions can use it.=20
  nft: Integrate nft translator engine in current core
        -> That patch is the step to retrieve a command structure from =
an nft rule, via the translation engine.=20
  nft: Manage xtables target parsing through translation tree
        -> Provides an instruction to support xt target expression list=
 in the translation tree
  nft: Manage xtables matches through nft translation tree
        -> Same for xt match expression list
  nft: Add support for xtables extensions callback to change cs
        -> This is debatable: xtables extensions have no access to the =
command structure,
            so instead I introduced such callback mecanism.=20
  xtables: Add support for registering nft translation function for
    target
        -> Hook for registering an instruction into a translation tree,=
 from an xtables target extension.
  xtables: Add support for registering nft translation function for
    match
        -> Same for an xtables match extension
  nft: Register all relevant xtables extensions into translation tree
        ->=C2=A0That one is debatable, but I needed a way to register r=
elevant extensions (ones providing translation instruction).
           Note: This works _only_ if you build with --enable-static. I=
 think it requires another solution, adding a pre_loading
                 function to libxtables maybe so it could work with sha=
red/static build.
                 This is the main reason why I send this as an RFC.=20
  nft: Refactor firewall printing so it reuses already parsed cs struct
        -> Now we can scrap the old code which was multiple times going=
 through the expression list, and use the command structure
  nft: Refactor rule deletion so it compares both cs structure
        -> Same but when deleting a rule: let's use the command structu=
r.
  nft: Remove useless function
        ->=C2=A0Ok that one is a trivial fix, actually I should have se=
nd it appart of this patch set.
  xtables: nft: Complete refactoring on how rules are saved
        -> Same for listing or deleting rule: here again old code is sc=
rapped to be able to use the command structure instead
  xtables: Support pure nft expressions for DNAT extension
        -> Now here is an example of an extension which can translate i=
ts blob into pure nft expressions, and can rebeilt
           its blog from nfs expression via registering the right instr=
uctions/parsing function as descriped above.

 Makefile.am                   |   3 +
 configure.ac                  |   8 +
 extensions/GNUmakefile.in     |   1 +
 extensions/libipt_DNAT.c      | 220 +++++++++++
 include/nft-translator.h      |  85 ++++
 include/xtables.h.in          |  14 +
 iptables/Makefile.am          |   3 +-
 iptables/nft-ipv4.c           | 125 ++----
 iptables/nft-ipv6.c           |  81 ++--
 iptables/nft-shared.c         |  72 +++-
 iptables/nft-shared.h         |  23 +-
 iptables/nft-xt-ext.c         | 181 +++++++++
 iptables/nft-xt-ext.h         |  14 +
 iptables/nft.c                | 893 +++++++++++++---------------------=
--------
 iptables/nft.h                |   8 +-
 iptables/xtables-events.c     |  21 +-
 libnfttrans/Makefile.am       |  28 ++
 libnfttrans/libnfttrans.pc.in |  11 +
 libnfttrans/nft-translator.c  | 618 +++++++++++++++++++++++++++++
 19 files changed, 1637 insertions(+), 772 deletions(-)
 create mode 100644 include/nft-translator.h
 create mode 100644 iptables/nft-xt-ext.c
 create mode 100644 iptables/nft-xt-ext.h
 create mode 100644 libnfttrans/Makefile.am
 create mode 100644 libnfttrans/libnfttrans.pc.in
 create mode 100644 libnfttrans/nft-translator.c

--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
