From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] New behaviour for early_drop()
Date: 14 Apr 2003 16:06:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1050329196.11154.244.camel@tux.rsn.bth.se>
References: <200304141140.18647.francesco@unipg.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Francesco Sportolari <francesco@unipg.it>
In-Reply-To: <200304141140.18647.francesco@unipg.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-04-14 at 11:40, Francesco Sportolari wrote:
> Hi all,
> this is a little patch to modify the behaviour of the early_drop() function; 
> now it uses the ip_conntrack_drop_list, a double-linked list of all the 
> non-assured connections. It costs 2 bytes more for the ip_conntrack struct
> and a pair of list_append() and list_del() ops, but would have to do better 
> under heavy loads and some type of attacks against the hash chains.

I've thought about something like this as well... The problem is that
this probably makes it easier to attack a certain chain. Earlier we
tried to delete an entry fromthe chain we were about to put the new into
and if that failed we tried another chain and if that failed we dropped
the new connection.

Now we can add the new entry into the chain as long as there's at least
one entry that can be deleted in the entire hashtable. Thus we can get a
_very_ long chain. But if it's a normal attack these entries will get
reaped and their places reused, eventually. But we'll probably get the
very long chain before they start getting reused.

Another approach might be to leave it the way it is right now but change
it to purge several entries at once if the chain-length is above a
certain level.

-- 
/Martin
