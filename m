From: "Horton, Dave" <dhorton@pactolus.com>
Subject: can a netfilter hook interact with userspace ?
Date: Mon, 19 Jul 2004 00:29:41 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <2CC2CB3C95C3D311ABAC009027DCD77E01969075@flyhalf.pactolus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I want to write a netfilter hook to do some specialized packet routing with
greatest efficiency.  However, the actions taken in my netfilter hook need
to be driven by decisions made in a user process (ie which ports to forward,
etc change based on knowledge only known to my user process).  

By what means can my userspace program call into my netfilter hook to
communicate this information?
