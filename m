From: diegows <diegows@linux.org.ar>
Subject: checkentry() and detroy ()  called multiple times
Date: Mon, 12 May 2003 11:22:00 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBFAE08.5050006@linux.org.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I 'm doing a match module and I have i little confusion.

If I insert a rule using my match module, I see that checkentry() is 
called once. If I insert a rule using my match module again I see that 
checkentry() is called twice and destroy is called once, and If i insert 
a rule for third time I see that checkentry is called tree times and 
destroy twice.

Is this the right? why?
