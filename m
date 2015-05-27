From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH] libnetfitler_queue: receive security context info
Date: Wed, 27 May 2015 13:02:56 +0200
Message-ID: <5565A460.2090707@samsung.com>
References: <5562F8D9.50608@samsung.com> <20150526131105.GE7817@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15882 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbE0LDA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:03:00 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP0004J69CXULA0@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 27 May 2015 12:02:57 +0100 (BST)
In-reply-to: <20150526131105.GE7817@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok so I updated the libnetfilter_queue and the example, i'll try to get to the libmnl asap but it looks a bit more challenging.


This will allow userspace to find the security context of each
packet (if it exists) and make decisions based on that.
It should work for SELinux and SMACK.

Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
---
v2:
- returning the size of security context
- updated the test program
---
 include/libnetfilter_queue/libnetfilter_queue.h    |  2 ++
 include/libnetfilter_queue/linux_nfnetlink_queue.h |  4 +++-
 include/linux/netfilter/nfnetlink_queue.h          |  4 +++-
 src/libnetfilter_queue.c                           | 21 +++++++++++++++++++++
 utils/nfqnl_test.c                                 | 12 +++++++++++-
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 122cd10..489e76d 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -105,6 +105,7 @@ extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
 extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
 extern int nfq_get_uid(struct nfq_data *nfad, u_int32_t *uid);
 extern int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid);
+extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
 
 extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			      struct nfq_data *nfad, char *name);
@@ -129,6 +130,7 @@ enum {
 	NFQ_XML_TIME	= (1 << 5),
 	NFQ_XML_UID	= (1 << 6),
 	NFQ_XML_GID	= (1 << 7),
+	NFQ_XML_SECCTX  = (1 << 8),
 	NFQ_XML_ALL	= ~0U,
 };
 
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index f732201..479faa3 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -52,6 +52,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,
 
 	__NFQA_MAX
 };
@@ -105,7 +106,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_CONNTRACK		(1 << 1)
 #define NFQA_CFG_F_GSO			(1 << 2)
 #define NFQA_CFG_F_UID_GID		(1 << 3)
-#define NFQA_CFG_F_MAX			(1 << 4)
+#define NFQA_CFG_F_SECCTX		(1 << 4)
+#define NFQA_CFG_F_MAX			(1 << 5)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 22f5d45..030672d 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -49,6 +49,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,
 
 	__NFQA_MAX
 };
@@ -102,7 +103,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
 #define NFQA_CFG_F_GSO				(1 << 2)
 #define NFQA_CFG_F_UID_GID			(1 << 3)
-#define NFQA_CFG_F_MAX				(1 << 4)
+#define NFQA_CFG_F_SECCTX			(1 << 4)
+#define NFQA_CFG_F_MAX				(1 << 5)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 740b340..530df06 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1219,6 +1219,27 @@ int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid)
 EXPORT_SYMBOL(nfq_get_gid);
 
 /**
+ * nfq_get_secctx - get the security context for this packet
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param secdata data to write the security context to
+ *
+ * \return -1 on error, otherwise > 0
+ */
+int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
+{
+	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
+		return -1;
+
+	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data, NFQA_SECCTX, char);
+
+	if (*secdata)
+		return NFA_PAYLOAD(nfad->data[NFQA_SECCTX-1]);
+		
+	return 0;
+}
+EXPORT_SYMBOL(nfq_get_secctx);
+
+/**
  * nfq_get_payload - get payload 
  * \param nfad Netlink packet data handle passed to callback function
  * \param data Pointer of pointer that will be pointed to the payload
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 2176a61..bee325b 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -17,7 +17,7 @@ static u_int32_t print_pkt (struct nfq_data *tb)
 	struct nfqnl_msg_packet_hw *hwph;
 	u_int32_t mark, ifi, uid, gid;
 	int ret;
-	unsigned char *data;
+	unsigned char *data, *secdata;
 
 	ph = nfq_get_msg_packet_hdr(tb);
 	if (ph) {
@@ -61,6 +61,10 @@ static u_int32_t print_pkt (struct nfq_data *tb)
 	if (nfq_get_gid(tb, &gid))
 		printf("gid=%u ", gid);
 
+	ret = nfq_get_secctx(tb, &secdata);
+	if (ret > 0)
+		printf ("secctx=\"%.*s\" ", ret, secdata);
+
 	ret = nfq_get_payload(tb, &data);
 	if (ret >= 0)
 		printf("payload_len=%d ", ret);
@@ -134,6 +138,12 @@ int main(int argc, char **argv)
 				"retrieve process UID/GID.\n");
 	}
 
+	printf("setting flags to request security context\n");
+	if (nfq_set_queue_flags(qh, NFQA_CFG_F_SECCTX, NFQA_CFG_F_SECCTX)) {
+		fprintf(stderr, "This kernel version does not allow to "
+				"retrieve security context.\n");
+	}
+
 	printf("Waiting for packets...\n");
 
 	fd = nfq_fd(h);
-- 
1.9.1


On 05/26/2015 03:11 PM, Florian Westphal wrote:
> Roman Kubiak <r.kubiak@samsung.com> wrote:
>> From: RomanKubiak <r.kubiak@samsung.com>
>> Date: Mon, 25 May 2015 12:24:34 +0200
>> Subject: [PATCH] libnetfitler_queue: receive security context info
>>
>> This will allow userspace to find the security context of each
>> packet (if it exists) and make decisions based on that.
>> It should work for SELinux and SMACK.
>>
>> ---
>>  include/libnetfilter_queue/libnetfilter_queue.h    |  2 ++
>>  include/libnetfilter_queue/linux_nfnetlink_queue.h |  4 +++-
>>  include/linux/netfilter/nfnetlink_queue.h          |  4 +++-
>>  src/libnetfilter_queue.c                           | 18 ++++++++++++++++++
>>  utils/nfqnl_test.c                                 | 11 ++++++++++-
>>  5 files changed, 36 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
>> index 122cd10..489e76d 100644
>> --- a/include/libnetfilter_queue/libnetfilter_queue.h
>> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
>> @@ -105,6 +105,7 @@ extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
>>  extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
>>  extern int nfq_get_uid(struct nfq_data *nfad, u_int32_t *uid);
>>  extern int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid);
>> +extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
>>  
>>  extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
>>  			      struct nfq_data *nfad, char *name);
>> @@ -129,6 +130,7 @@ enum {
>>  	NFQ_XML_TIME	= (1 << 5),
>>  	NFQ_XML_UID	= (1 << 6),
>>  	NFQ_XML_GID	= (1 << 7),
>> +	NFQ_XML_SECCTX  = (1 << 8),
>>  	NFQ_XML_ALL	= ~0U,
>>  };
>>  
>> diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
>> index f732201..479faa3 100644
>> --- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
>> +++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
>> @@ -52,6 +52,7 @@ enum nfqnl_attr_type {
>>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>>  	NFQA_UID,			/* __u32 sk uid */
>>  	NFQA_GID,			/* __u32 sk gid */
>> +	NFQA_SECCTX,
>>  
>>  	__NFQA_MAX
>>  };
>> @@ -105,7 +106,8 @@ enum nfqnl_attr_config {
>>  #define NFQA_CFG_F_CONNTRACK		(1 << 1)
>>  #define NFQA_CFG_F_GSO			(1 << 2)
>>  #define NFQA_CFG_F_UID_GID		(1 << 3)
>> -#define NFQA_CFG_F_MAX			(1 << 4)
>> +#define NFQA_CFG_F_SECCTX		(1 << 4)
>> +#define NFQA_CFG_F_MAX			(1 << 5)
>>  
>>  /* flags for NFQA_SKB_INFO */
>>  /* packet appears to have wrong checksums, but they are ok */
>> diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
>> index 22f5d45..030672d 100644
>> --- a/include/linux/netfilter/nfnetlink_queue.h
>> +++ b/include/linux/netfilter/nfnetlink_queue.h
>> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>>  	NFQA_UID,			/* __u32 sk uid */
>>  	NFQA_GID,			/* __u32 sk gid */
>> +	NFQA_SECCTX,
>>  
>>  	__NFQA_MAX
>>  };
>> @@ -102,7 +103,8 @@ enum nfqnl_attr_config {
>>  #define NFQA_CFG_F_CONNTRACK			(1 << 1)
>>  #define NFQA_CFG_F_GSO				(1 << 2)
>>  #define NFQA_CFG_F_UID_GID			(1 << 3)
>> -#define NFQA_CFG_F_MAX				(1 << 4)
>> +#define NFQA_CFG_F_SECCTX			(1 << 4)
>> +#define NFQA_CFG_F_MAX				(1 << 5)
>>  
>>  /* flags for NFQA_SKB_INFO */
>>  /* packet appears to have wrong checksums, but they are ok */
>> diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
>> index 740b340..9356e3d 100644
>> --- a/src/libnetfilter_queue.c
>> +++ b/src/libnetfilter_queue.c
>> @@ -1219,6 +1219,24 @@ int nfq_get_gid(struct nfq_data *nfad, u_int32_t *gid)
>>  EXPORT_SYMBOL(nfq_get_gid);
>>  
>>  /**
>> + * nfq_get_secctx - get the security context for this packet
>> + * \param nfad Netlink packet data handle passed to callback function
>> + * \param secdata data to write the security context to
>> + *
>> + * \return 1 if there is a security context available, 0 otherwise
>> + */
>> +int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
>> +{
>> +	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
>> +		return 0;
>> +
>> +	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data, NFQA_SECCTX, char);
>> +
>> +	return 1;
> 
> This should return the attr size, see nfq_get_payload() below on how to
> do this.
> 
> It would be nice if you could add libmnl based version too
> (src/nlmsg.c contains libmnl api of libnetfilter_queue).
> 
> The short version is that libnfnetlink has problems wrt.
> extensibility/flexibility since it hides netlink details.
> 
> libmnl exposes all of the netlink data so its more flexible to add
> functionality on top of libmnl than on top of libnfnetlink.
> 
> And on top of that, libnetfilter_queue libnfnetlink api exposes/leaks
> implementation details of libnfnetlink so we can't replace libnfnetlink
> with libmnl in the higer level libraries :-(
> 
> 

-- 
--------------
 Roman Kubiak
--------------
