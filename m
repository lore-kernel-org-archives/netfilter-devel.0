From: Alistair Tonner <Alistair@nerdnet.ca>
Subject: Re: Memory leaks in ip_conntrack?
Date: Tue, 11 Nov 2003 08:54:44 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <200311110854.44805.Alistair@nerdnet.ca>
References: <Pine.LNX.4.44.0311111424150.16497-100000@filer.marasystems.com>
Reply-To: Alistair@nerdnet.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Kishore Dharmavaram <kishored@servgate.com>,
  <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>, Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <Pine.LNX.4.44.0311111424150.16497-100000@filer.marasystems.com>
Content-Disposition: inline
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On November 11, 2003 08:24 am, Henrik Nordstrom wrote:
> On Mon, 10 Nov 2003, Daniel Chemko wrote:
> > Ack! (slaps head)
> >
> > I was a victim of this! I finally have a reason for all those annoying
> > TCP window error messages! Who knows, I may actually have 'traffic'
> > through my gateway at this rate.
>
> tcp_wmem should not be related to forwarded traffic at all, only for local
> TCP sockets..
>
> Regards
> Henrik


	Okay -- thanks Henrik ... I wasn't sure of where that allocation applied, and 
my problem is I *firmly* disbelieve in coincidence .... 


-- 

	Alistair Tonner
	nerdnet.ca
	Senior Systems Analyst - RSS
	
     Any sufficiently advanced technology will have the appearance of magic.
	Lets get magical!
