From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Differences between MASQ and SNAT
Date: Tue, 10 Feb 2004 02:04:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402100201020.31980-100000@filer.marasystems.com>
References: <1076330570.8454.13.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jimmy Hedman <jimmy.hedman@southpole.se>
In-Reply-To: <1076330570.8454.13.camel@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 9 Feb 2004, Jimmy Hedman wrote:

> What's the REAL differences between MASQ and SNAT?

MASQ kills the connections whenthe IP address of the interface changes, 
SNAT does not.

MASQ is limited in what kind of NAT transform it can perform. SNAT gives 
some more freedom in what addresses is used for the NAT.

Other than this the two are supposed to be the same, and I do not see how
they can be any different as all the targets does is to set up the NAT 
transform. The actual NAT is always the same.

Regards
Henrik
