From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Sharing information for many rules using same module
Date: Tue, 21 Aug 2007 17:15:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708211713130.5333@fbirervta.pbzchgretzou.qr>
References: <6ed0182d.25662f4f.46cafca9.d1786@o2.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-1021822510-1187709338=:5333"
Cc: netfilter-devel@lists.netfilter.org
To: =?UTF-8?Q?=C5=81ukasz_Stosik?= <litestep@o2.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <6ed0182d.25662f4f.46cafca9.d1786@o2.pl>
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

---699020219-1021822510-1187709338=:5333
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Aug 21 2007 16:54, =C5=81ukasz Stosik wrote:

>I am working on simple netfilter match extension. It takes packet,
>analyzes it, and puts all info in structure. Then it looks at fields
>in matchinfo and decides if there is a match or not.

>The problem is there will be probably many rules, and each time
>module will repeat the first part of process- where it would be
>enought to use same structure as in first rule. Is there any way to
>share info between rules?

Use a global variable (hash, linked list, whatever) in
xt_yourmatch.c.

>I would also like to know if netfilter is processing packetss in
>pararell - or maybe i can be sure that until packet gets dropped or
>reaches NIC driver, netfilter wont start to process another one -
>that would solve my problem as i could simply keep that info inside
>matching module.

You have to assume that it does things in parallel, and hence need
proper locking around your global variable.

>And BTW something offtopic - what is ( is there any) a good way to
>access userspace memory

copy_from_user(), but only if you have a user context. Which you
generally do not during input packet processing.

> ( for example some process gets information
>from databases, and i need that data inside kernel ) from kernel
>module ?

Think of something else.



	Jan
--=20
---699020219-1021822510-1187709338=:5333--
