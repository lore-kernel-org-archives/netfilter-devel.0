From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Nat Code Confusion
Date: Fri, 20 Jun 2003 03:51:03 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F67MARCtZoFK8o000663ae@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi,

The confused one is back. As usual, a couple of grey areas:

1.  Under the data_fixup section for nat, e.g. amanda, there's this line:

         newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;

     What's the rationale for selecting the direction to use?

2.  Under the nat_expected similar for amanda, the following lines:

	newdstip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
	newsrcip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;

     Again, what's the rationale for selecting the direction and in each 
case, ct or master to use?


3. Just a wild observation. Is the Harald the official spokesman for 
netfilter as it seems he's the only guy
    answering all the questions.

Ok, that's it.

    Ricky

_________________________________________________________________
Keep track of Singapore stock prices. http://www.msn.com.sg/money/
