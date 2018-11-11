From: "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH net-next 0/9] Use __vlan_hwaccel_*() helpers
Date: Sun, 11 Nov 2018 17:12:43 +0100
Message-ID: <20181111161243.GA12849@qmqm.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
	<20181108.204523.1353698272847299871.davem@davemloft.net>
	<28a275b4-4fd5-2c00-217a-c6ab69fb2ad9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
	"somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
	"kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"swise@chelsio.com" <swise@chelsio.com>,
	"nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
	"roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
	"jhs@mojatatu.com" <jhs@mojatatu.com>,
	"sathya.perla@broadcom.com" <sathya.perla@broadcom.com>,
	"xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
	"mlindner@marvell.com" <mlindner@marvell.com>,
	"sriharsha.basavapatna@broadcom.com"
To: Tariq Toukan <tariqt@mellanox.com>
Return-path: <bridge-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <28a275b4-4fd5-2c00-217a-c6ab69fb2ad9@mellanox.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Nov 11, 2018 at 03:26:29PM +0000, Tariq Toukan wrote:
> 
> 
> On 09/11/2018 6:45 AM, David Miller wrote:
> > From: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> > Date: Fri, 09 Nov 2018 00:17:58 +0100
> > 
> >> This series removes from networking core and driver code an assumption
> >> about how VLAN tag presence is stored in an skb. This will allow to free
> >> up overloading of VLAN.CFI bit to incidate tag's presence.
> > 
> > This looks good, series applied.
> > 
> > Thanks.
> > 
> 
> Hi Michal,
> 
> We started seeing the compilation errors below, they look related to 
> this series.

Do you have the previous series applied that introduced __vlan_hwaccel_clear_tag()?
It was applied to net-next before I sent this series.

I did a allmodconfig build of net-next and saw no failures (apart from
OVS that is fixed already).

Best Regards,
Micha³ Miros³aw
