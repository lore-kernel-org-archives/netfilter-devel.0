From: Kovacs Krisztian <hidden@balabit.hu>
Subject: Re: Conntrack and high avaibility
Date: Wed, 17 Sep 2003 17:22:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F687C27.20100@balabit.hu>
References: <1063725970.2697.11.camel@sasa> <1063811052.3843.78.camel@aolin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: diegows@linux.org.ar, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alex Ongena <Alex.Ongena@able.be>
In-Reply-To: <1063811052.3843.78.camel@aolin>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Alex Ongena wrote:
 > Hi,
 > We have the same problem and have not yet found a fix.
 > Are we the only ones ?
 > Alex
 > On Tue, 2003-09-16 at 17:26, Diego Woitasen wrote:
 >
 >>I need a firewall with HA, transparent to the user, but i have the
 >>problem of conntrack. When the stand-by firewall become active the
 >>conntrack is started from zero (all connection must be establish again).
 >>Exists a project to transfer conntrack information between firewalls?
 >>If not? This is feasible to do it? If this is feasible i want to start
 >>working on it.

   No, you're not alone at all. The need for a failover solution for 
Netfilter is well known and understood. If you're interested in the 
current state of design and development, take a look at

http://lists.netfilter.org/pipermail/netfilter/2003-September/046837.html

-- 
   Regards,
     Krisztian KOVACS
