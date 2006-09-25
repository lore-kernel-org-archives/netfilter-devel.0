From: Giacomo <delleceste@gmail.com>
Subject: news about retrieving kernel symbols (tasklist_struct)
Date: Mon, 25 Sep 2006 17:25:11 +0200
Message-ID: <885896af0609250825k7d0afda9x50fbc8f8a9d73913@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
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

Good afternoon.
As to the need to retrieve the symbol tasklist_lock, which is no more
exported in kernel 2.6.18, i tried to use the

kallsyms_lookup_name("tasklist_lock");

function.

It returns an unsigned long which should be the address of the symbol,
e.g. the variable tasklist_lock.



So i tried to use it, but it does not work!

-------------------------------------------------------------------
rwlock_t tasklist_lock_from_symbol;
unsigned long tlockptr;

tlockptr =  kallsyms_lookup_name("tasklist_lock");

if( tlockptr == 0)
	return NULL;

printk("symbol: 0x%lx\n",  tlockptr);

memcpy(&tasklist_lock_from_symbol, (void*) &tlockptr, sizeof(rwlock_t) );

read_lock(&tasklist_lock_from_symbol);
(...)
---------------------------------------------------------------------

Perhaps this is not the right way to retrieve the address of the variable...

thanks a lot


-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Proteggi il tuo PC provando il mio semplice FIREWALL:
http://www.giacomos.it/ipfire

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
