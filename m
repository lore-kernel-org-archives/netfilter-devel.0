From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: init_conntrack() low hanging fruit
Date: Sun, 7 Jul 2002 13:40:53 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207071340.53733@henrik.marasystems.com>
References: <20020707123754.K13116@oknodo.bof.de> <20020707125141.L13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020707125141.L13116@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 07 July 2002 12.51, Patrick Schaaf wrote:
> Just spotted one more thing, rediff appended. Now that I've saved
> some horizontal screen real estate, the drop error can be
> single-line again...

drop_next should most likely be made voilatile to protect from 
compiler optimization evilness, and you may need to care for 
alignment etc.... using atomic_t as proposed earlier feels like a 
good bet.

   static atomic_t drop_next = ATOMIC_INIT(0);
   int victim = atomic_read(&drop_next);
   int next = victim + 1;
   atomic_set(&drop_next, (next < ip_conntrack_htable_size) ? next : 
0);

To other readers: We do not need to SMP synchronize here.. only SMP 
criteria is that the value cannot be badly corrupted by concurrent 
read/write to produce a invalid reading. It does not matter if a few 
(or even many) iterations of drop_next is lost/forgotten/skipped.

Regards
Henrik
