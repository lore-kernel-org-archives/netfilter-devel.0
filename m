From: Brad Fisher <brad@info-link.net>
Subject: Time match in mangle/POSTROUTING?
Date: Tue, 02 Dec 2003 18:13:21 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCD2AA1.6F5E0225@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fabrice@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm curious why the time match doesn't work in POSTROUTING?  I have an
application where it would be helpful to use it as such and was
wondering if there was a good technical reason why it shouldn't work.
If I modified the source to allow it to be added to the POSTROUTING
chain, would it work as expected?  I'm assuming it won't be as simple as
that...

-Brad
