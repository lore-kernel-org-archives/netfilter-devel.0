From: Dan Eble <dane@aiinet.com>
Subject: Counter index question
Date: Mon, 16 Sep 2002 15:43:27 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209161543020.26390-100000@dane-linux.aiinet.com>
Reply-To: <dane@aiinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Does c->end point to a valid entry?  TC_DELETE_ENTRY and other functions
forbid operating on an entry at c->end, which indicates that it is not
valid.  If that is the case, why do the counter functions allow it?  For
example, from libiptc.c:

TC_READ_COUNTER(...)
{
        ...

        chainindex = entry2index(*handle, c->start);
        end = entry2index(*handle, c->end);

        if (chainindex + rulenum > end) {
                errno = E2BIG;
                return NULL;
        }

        e = index2entry(*handle, chainindex + rulenum);

        ...
}
