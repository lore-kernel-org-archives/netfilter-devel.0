From: Robert Scott <rbscott@cadvium.net>
Subject: nfq_set_verdict_mark
Date: Sun, 1 Oct 2006 13:09:36 -0700
Message-ID: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

i noticed that this function doesn't automatically convert the mark  
into the expected network byte order.  this is a minor detail, but  
the current behavior may confuse users. since nfq_get_nfmark  
automatically converts the mark into host order, i thought  
nfq_set_verdict_mark would also  do the reverse.

not really a big deal, and this will probably break most existing  
installations in the field, but perhaps a note in the docs to give  
new users a heads up.

cheers,
--robert
