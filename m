From: Thomas <toom@docisland.org>
Subject: ctnetlink weird events on ipsec connections
Date: Tue, 10 May 2005 15:52:32 +0200
Message-ID: <1115733152.10793.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: 1115048084.12112.52.camel@localhost.localdomain
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

your patch solves my problem

Thanks

Thomas

Pablo Neira wrote:
> I recently posted a patch to delete the use of nfcache in ip_tables, 
> this causes some interferences to the conntrack-event-api. I think that 
> it could be related to your problem.
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2005-May/019574.html
> 
> Could you give it a try and let me know if it fixes your problem?
