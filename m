From: Giacomo <delleceste@gmail.com>
Subject: Fwd: locking while reading linked lists.
Date: Wed, 23 Nov 2005 09:17:46 +0100
Message-ID: <885896af0511230017n25e1dec8p@mail.gmail.com>
References: <885896af0511230016r3eb7b0b7j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <885896af0511230016r3eb7b0b7j@mail.gmail.com>
Content-Disposition: inline
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

---------- Forwarded message ----------
From: Giacomo <delleceste@gmail.com>
Date: 23-nov-2005 9.16
Subject: locking while reading linked lists.
To: netfilter devel <netfilter-devel@lists.netfilter.org>


Good morning.
In a packet filter which i wrote on my own, i have a linked list of structu=
res
which i read periodically by means of list_for_each_safe macro.
These structures have a timer, when it expires, the entry is deleted.
The timer can on the other way be updated by mod_timer.

The context of execution is that of a software interrupt (i attach my code =
at
netfilter hooks), and some times (after tenths of millions of packets filte=
red)
the system goes into panic.

I think i should put some locks when reading in list_for_each or when
deleting an item, or when updating timers.

I thought it was not necessary because of the atomic context.

In fact, should i use read/write_lock? Or spinlocks?

Should i put the locks when reading in list_for_each, when adding an entry
with list_add, when deleting with list_del and also when mod_timer?

I verified that when i put those locks, things go better, but do i need the=
m
so many in my code?

Thanks in advance

Giacomo.





--

Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Running `IPFIRE-wall` on debian GNU/Linux
http://www.giacomos.it/ipfire
http://www.debian.org

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -


--

Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Running `IPFIRE-wall` on debian GNU/Linux
http://www.giacomos.it/ipfire
http://www.debian.org

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -
