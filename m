From: Bart <b-m@pandora.be>
Subject: ULOG problem
Date: Wed, 30 Oct 2002 16:41:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DBFFDA2.1020108@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

When I insert a rule like this:

-j ULOG --ulog-prefix "inet in"

then iptables-save will show:

-j ULOG --ulog-prefix inet in

and restoring won't work...

Is there already a fix for this ?

Greetz
