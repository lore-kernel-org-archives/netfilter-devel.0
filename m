From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: TOS target broken wrt ECN (was RFC 1349)
Date: Thu, 29 Apr 2004 18:31:15 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0404291748430.5102@chris.camcom.co.uk>
References: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

Sorry to bother you again, but based on the information in the RFCs 
(condensed):

  RFC 1349:

         0     1     2     3     4     5     6     7
      +-----+-----+-----+-----+-----+-----+-----+-----+
      |   PRECEDENCE    |          TOS          | MBZ |
      +-----+-----+-----+-----+-----+-----+-----+-----+

  RFC 2474:

        0   1   2   3   4   5   6   7
      +---+---+---+---+---+---+---+---+
      |         DSCP          |  CU   |
      +---+---+---+---+---+---+---+---+

  RFC 3168:

         0     1     2     3     4     5     6     7
      +-----+-----+-----+-----+-----+-----+-----+-----+
      |          DS FIELD, DSCP           | ECN FIELD |
      +-----+-----+-----+-----+-----+-----+-----+-----+

Would you say that the bits allocated to ECN overlap with the old TOS and 
MBZ fields (as it appears to me now), rather than the bit order being 
reversed in one or two of these diagrams?

If so, then the TOS target is dangerous since it will disrupt the 
operation of ECN, and the documentation should mention that. I'd be happy 
to write a patch to update it if people are interested.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
