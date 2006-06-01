From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables CLASSIFY and MARK not working?
Date: Thu, 01 Jun 2006 21:44:12 +0200
Message-ID: <447F438C.4080606@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255419@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: "Eliot, Wireless and Server Administrator,  Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB255419@xavier.staff.greatlakes.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Both devices (br1 and wivl4) are bridged interfaces with spanning tree
> turned on. They also do VLANs. Specifically, vconfig was used to create
> a VLAN (in this case, VLAN 4) on two interfaces: eth2 and eth3. These
> two VLAN interfaces were called e2v4 and e3v4. Then, brctl was used to
> bridge the two VLAN interfaces (e2v4 and e3v4) into a new interface
> called wivl4. Spanning tree was then enabled on wivl4. The MTU size was
> then adjusted -4 bytes to accommodate the VLAN tagging. 

Any chance you got bridge netfilter enabled? If so please disable
it and try again (or set the bridge-nf-call-iptables sysctl to 0).

> Also, did you happen to try my specific rules (under different devices)
> to see if they work? 

No, just tried CLASSIFY with my own HFSC setup, which is pretty
similar.

> If possible, could you try creating a VLAN interface and test on that
> interface? Then try a bridged interface. And finally, a bridged VLAN
> interface. 
> 
> I will try to set this all up on a different machine without the bridged
> VLANs and see if it works there.

I checked the code, neither VLAN nor bridge should matter.
