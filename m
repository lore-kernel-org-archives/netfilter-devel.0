From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT and locally bound sockets
Date: Tue, 2 Jul 2002 09:52:20 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207020952.20868@henrik.marasystems.com>
References: <20020529164926.GA9003@gort.ecn.purdue.edu> <200207011859.39589.hno@marasystems.com> <20020701184615.GA13296@lucky>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: shuey@purdue.edu
In-Reply-To: <20020701184615.GA13296@lucky>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 01 July 2002 20.46, Michael Shuey wrote:

> First, why would I want to SNAT locally originating packets? 
> Second, are you telling me that netfilter _does_ check to see if a
> port is locally bound before using it for a translation?

Mainly in case the locally selected port is already in use by a NAT:ed 
connection.

NAT checks to see that the port isn't already in use by NAT or local 
sockets, but as far as I know local traffic do not check that the 
port isn't already in use by NAT.

By applying SNAT to the locally originating traffic as well the NAT 
engine will detect any such collisions and reassign the port 
automatically.

Regards
Henrik
