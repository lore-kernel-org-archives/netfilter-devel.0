From: Richard Scobie <richard@sauce.co.nz>
Subject: H.323 progress.
Date: Tue, 18 May 2004 10:56:29 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A9431D.8020404@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

I have a FreeSwan IPsec VPN between 2 iptables NAT boxes.

With H.323 videoconferencing equipment from both Via Video and Tandberg, 
I have been unable to get complete connection between both ends through 
the VPN - 90+ % of the time, video connects both ways and audio only one.

The same setup using 2.2 kernels and ipchains works fine every time.

After finding some information in the list archives, I was just wanting 
to confirm that the problem I am seeing is due to the current H.323 
helper modules and also whether these modules are currently being 
actively developed?

Regards,

Richard
