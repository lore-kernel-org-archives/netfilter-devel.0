From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: performance issues (nat / conntrack)
Date: Fri, 21 Jun 2002 10:35:05 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15635.25545.469973.950625@isis.cs3-inc.com>
References: <20020621132640.2C326472B@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org,
	"Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <20020621132640.2C326472B@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > I'm doing some tcp benches on a netfilter enabled box and noticed
 > huge and surprising perf decrease when loading iptable_nat module. 
Rather similar to the results I posted about a week ago.

 > - Another (old) question: why are conntrack or nat active when there are
 > no rules configured (using them or not)? 
I noticed this too.  After a test using conntrack the next test
without "using" conntrack would perfom poorly unless I did rmmod.

 > Since in my test, each connection is ephemeral (<10ms) ...
When all works correctly, the end of each connection should be noticed
by conntrack and the connection removed from the table, right?
In which case the table should never get very full.
So I'm guessing that large number of entries in conntrack table is
evidence that packets are being lost.  In particular, if the syn
packet arrives but is never forwarded, you get one of those conntrack
entries where conntrack thinks (incorrectly) the syn has been
forwarded so it's waiting for the reply.  Ideally the entry should
not be added to the table until the packet goes out.

Just wondering, how did you measure cpu load?
