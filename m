From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Subject: MAC Filtering
Date: Wed, 5 Jan 2005 14:25:36 +0100
Message-ID: <200501051425.36450.erwin.vandevelde@gmail.com>
Reply-To: erwin.vandevelde@gmail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I'm designing software for a testlab for testing mobility protocols. I use 
wireless-over-wired links and link down events should be simulated by a 
blocking firewall on both ends. The nodes only have the source and 
destination MAC addresses for each link (it is possible that multiple 
interfaces have the same IP address and that different 'wireless' interfaces 
have different transmit ranges). 
Is it possible to filter on both the source and destination MAC address? I 
only found the option with source MAC address...
Ebtables is not an option as bridges are needed there.

If not possible with the normal netfilter, is there a patch that can do it? Is 
it even possible to do such a thing?

Thanks in adv,

Erwin Van de Velde
University of Antwerp
Belgium
