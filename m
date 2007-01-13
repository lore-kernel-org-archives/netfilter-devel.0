From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [nf-failover] Oops in ctnetlink_create_conntrack
Date: Sat, 13 Jan 2007 17:25:50 +0100
Message-ID: <200701131725.50973.simonl@parknet.dk>
References: <200701130319.30347.simonl@parknet.dk> <45A8F917.9080002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A8F917.9080002@trash.net>
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


Yes, verified.

Thanks a lot!


Regards
Simon


On Saturday 13 January 2007 16:21, Patrick McHardy wrote:
> Simon Lodal wrote:
> > Hello
> >
> > I got an oops in ctnetlink_create_conntrack when running 'conntrackd -c',
> > with a 'conntrackd -d' running. I hope this is the right place to report
> > this bug.
>
> Please CC netfilter-devel on bugreports.
>
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000004 printing eip:
> > *pde = 00000000
> > Oops: 0000 [#1]
> > SMP
> > Modules linked in: generic piix softdog e752x_edac eeprom i2c_dev
> > i2c_i801 i2c_core parport_pc parport sd_mod ide_cd cdrom ide_disk
> > usb_storage ide_core usbserial ehci_hcd uhci_hcd usbcore thermal
> > processor fan ata_piix libata scsi_mod raid1 md_mod CPU:    1
> > EIP:    0060:[<4029f2a7>]    Not tainted VLI
> > EFLAGS: 00010202   (2.6.18.5-r2.8-p4smp #1)
> > EIP is at ctnetlink_create_conntrack+0x6e/0x3a7
>
> I *think* this is already fixed in 2.6.19 by the attached patch.
>
> Can you verify whether the patch fixes the problem? If it does
> I'll push it to -stable.
