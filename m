From: Pablo Neira <pablo@eurodev.net>
Subject: ipt_entry_match and data field
Date: Fri, 07 May 2004 15:08:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409B8A3C.1030009@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

can anyone explain me the use of data as unsigned char in the structure 
ipt_entry_match? I mean, why are we using unsigned char?

----- snipped from ip_tables.h ------------------------

struct ipt_entry_match
{
        union {
                struct {
                        u_int16_t match_size;

                         /* Used by userspace */
                         char name[IPT_FUNCTION_MAXNAMELEN];
                } user;
                struct {
                        u_int16_t match_size;

                        /* Used inside the kernel */
                        struct ipt_match *match;
                } kernel;

                /* Total length */
                u_int16_t match_size;
         } u;

         unsigned char data[0];
};

------------ end ---------------------------

thanks,
Pablo
