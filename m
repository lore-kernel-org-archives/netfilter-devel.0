From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim 0/4] binary protocol support + backticks for nfsim
Date: Mon, 21 Feb 2005 18:17:19 +0100
Message-ID: <20050221171719.GA32254@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

this set of 4 patches adds support for binary protocols by escaping
all non-printable and 8 bit characters and by adding the "backtick"
feature known from the shell and perl. This enables you to write a
small program which generates packets for nfsim.

Without these patches, it is a major pain to write nfsim tests for
binary protocols like H.323.

Consider the following snippet (NAT helper test):

 expect gen_ip send:eth1 {*DATA `./generate-h225-connect 192.168.0.2`}
 tcpsession DATA original `./generate-h225-connect 192.168.0.1`

Now imagine the same expressed in inlined hex notation.

Max
