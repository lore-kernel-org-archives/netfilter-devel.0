From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:43:31 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206062143.31347.hno@marasystems.com>
References: <Pine.LNX.4.21.0206061947590.19481-100000@dns.toxicfilms.tv> <3CFFAF5D.4010103@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org,
	Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3CFFAF5D.4010103@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Fleury wrote:

> So, what are the INVALID packets ?????

Packets where it is impossible to identify a session key to use when matching 
reply packets as belonging to the same session. This is mostly malformed 
packets.

I think RST of a non-existing session also classifies as INVALID, but I am not 
sure.. and in reality does not matter much..

Regards
Henrik
