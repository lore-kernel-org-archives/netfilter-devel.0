Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20DAC00140
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Aug 2022 00:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiHFAZe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 20:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiHFAZd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 20:25:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA316E028
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Aug 2022 17:25:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso4297919pjl.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Aug 2022 17:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=w6ndu16jWvJryYJSjaAhhZRXCBGlmnDvx3uRH+ARgVo=;
        b=RcHgoYxRsObw7SBQ65WilhKpaYxOzJCLVCF4GfsSKHJbypBUQr/Gy6pI+miQCLPJLG
         ul/H9zLOvYen2diJKj6pgs8sha8o62FcDNCC5xGsuAPvM2A/476nKH0L/DuBWws1fKka
         VhchOtMWgrRKRtC86ckjVzXzPioxrtt3wzksmam1rXuQ8aAQsSOcNWhcckGnlThyh8QL
         mEFajcP3ylgEraOPZZxBtOf6FjFUT5PzI872SarjePQ7G36f3jQ5FLW7Iq6Zw4d/6GDL
         glA9MDo61iBRdo7rAB+vasZ6fGaXTfm6GCsHVTP4m/lcwmnrJhrTkw2bmRJQw0gYwnxc
         jW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=w6ndu16jWvJryYJSjaAhhZRXCBGlmnDvx3uRH+ARgVo=;
        b=T1NP4pvZwvQJP4Js1H+xtkR2rdPmXQHSJq2S/DZlNaWo8ntkxwSfG9UYeXIUVf/8rg
         03Y08I2zCF8s+BA4kGs9CDvdox7Zb0oRJBTAXFAc2MH+SfRaoqbA7Ug9j1Zp/PuF3d4+
         Vz82oZYAMfUlF5Vfk5JORLD0pZTq/35CuLro5bh8kWw05VFh7Y2tFGAH1jI53ICJ9IqP
         cH4okw4aWvTniSZoPm8EkIsHcCPARCOeBXphTleGde8mC8t/pHoTgmbEN84OdoHgdlCd
         EcZAPV8gZ3RioMs1Cht5XrVJi7ldQBgGEfbaUze/0ZedB/zwu/wkws1fZRx07CEzDcgM
         imlg==
X-Gm-Message-State: ACgBeo1AGfgk2uH+cO4hrdvOcOtKqoEqaM51z1JUUclg3ATXryJMVq4k
        dS/C9c51RPo2nBtO2rZWO2reSRzJPAg=
X-Google-Smtp-Source: AA6agR7I+ngxM9obvtGY/LWPrgEbYEUZk9lN0jKSzfYNbPyM2RfTUODBFV6ERq3292qbKQipQ8tYOg==
X-Received: by 2002:a17:90a:6fc5:b0:1f5:553:2d42 with SMTP id e63-20020a17090a6fc500b001f505532d42mr9887194pjk.176.1659745528684;
        Fri, 05 Aug 2022 17:25:28 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005289627ae6asm3612104pfc.187.2022.08.05.17.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 17:25:28 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sat, 6 Aug 2022 10:25:24 +1000
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl v2 1/2] libmnl: update attribute function comments
 to use \return
Message-ID: <Yu209OseJaKBCfbe@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Jacob Keller <jacob.e.keller@intel.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220805210040.2827875-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805210040.2827875-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 05, 2022 at 02:00:39PM -0700, Jacob Keller wrote:
> Update the function comments in lib/attr.c to use the \return notation,
> which produces better man page output.
>
> Suggested-by: Duncan Roe <duncan.roe2@gmail.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>
> Figured since I had copied documentation comment style from these, I should
> go ahead and fix them up as well. This fixes all of the function comments in
> attr.c to use the \return and reduce some of the unnecessary verbosity.
>
>  src/attr.c | 138 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 79 insertions(+), 59 deletions(-)
>
> diff --git a/src/attr.c b/src/attr.c
> index 838eab063981..20d48a370524 100644
> --- a/src/attr.c
> +++ b/src/attr.c
> @@ -33,7 +33,7 @@
>   * mnl_attr_get_type - get type of netlink attribute
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the attribute type.
> + * \return the attribute type
>   */
>  EXPORT_SYMBOL uint16_t mnl_attr_get_type(const struct nlattr *attr)
>  {
> @@ -44,8 +44,11 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_type(const struct nlattr *attr)
>   * mnl_attr_get_len - get length of netlink attribute
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the attribute length that is the attribute header
> - * plus the attribute payload.
> + * \return the attribute length
> + *
> + * The attribute length is the length of the attribute header plus the
> + * attribute payload.
> + *
>   */
>  EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
>  {
> @@ -56,7 +59,7 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
>   * mnl_attr_get_payload_len - get the attribute payload-value length
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the attribute payload-value length.
> + * \return the attribute payload-value length
>   */
>  EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
>  {
> @@ -67,7 +70,7 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
>   * mnl_attr_get_payload - get pointer to the attribute payload
>   * \param attr pointer to netlink attribute
>   *
> - * This function return a pointer to the attribute payload.
> + * \return pointer to the attribute payload
>   */
>  EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
>  {
> @@ -85,10 +88,12 @@ EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
>   * truncated.
>   *
>   * This function does not set errno in case of error since it is intended
> - * for iterations. Thus, it returns true on success and false on error.
> + * for iterations.
>   *
>   * The len parameter may be negative in the case of malformed messages during
>   * attribute iteration, that is why we use a signed integer.
> + *
> + * \return true if there is room for the attribute, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
>  {
> @@ -101,9 +106,11 @@ EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
>   * mnl_attr_next - get the next attribute in the payload of a netlink message
>   * \param attr pointer to the current attribute
>   *
> - * This function returns a pointer to the next attribute after the one passed
> - * as parameter. You have to use mnl_attr_ok() to ensure that the next
> - * attribute is valid.
> + * \return a pointer to the next attribute after the one passed in
> + *
> + * You have to use mnl_attr_ok() on the returned attribute to ensure that the
> + * next attribute is valid.
> + *
>   */
>  EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
>  {
> @@ -116,13 +123,17 @@ EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
>   * \param max maximum attribute type
>   *
>   * This function allows to check if the attribute type is higher than the
> - * maximum supported type. If the attribute type is invalid, this function
> - * returns -1 and errno is explicitly set. On success, this function returns 1.
> + * maximum supported type.
>   *
>   * Strict attribute checking in user-space is not a good idea since you may
>   * run an old application with a newer kernel that supports new attributes.
>   * This leads to backward compatibility breakages in user-space. Better check
>   * if you support an attribute, if not, skip it.
> + *
> + * On an error, errno is explicitly set.
> + *
> + * \return 1 if the attribute is valid, -1 otherwise
> + *
>   */
>  EXPORT_SYMBOL int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
>  {
> @@ -201,8 +212,11 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
>   * \param type data type (see enum mnl_attr_data_type)
>   *
>   * The validation is based on the data type. Specifically, it checks that
> - * integers (u8, u16, u32 and u64) have enough room for them. This function
> - * returns -1 in case of error, and errno is explicitly set.
> + * integers (u8, u16, u32 and u64) have enough room for them.
> + *
> + * On an error, errno is explicitly set.
> + *
> + * \return 0 on success, -1 on error
>   */
>  EXPORT_SYMBOL int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
>  {
> @@ -223,8 +237,12 @@ EXPORT_SYMBOL int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_dat
>   * \param exp_len expected attribute data size
>   *
>   * This function allows to perform a more accurate validation for attributes
> - * whose size is variable. If the size of the attribute is not what we expect,
> - * this functions returns -1 and errno is explicitly set.
> + * whose size is variable.
> + *
> + * On an error, errno is explicitly set.
> + *
> + * \return 0 if the attribute is valid and fits within the expected length, -1
> + * otherwise
>   */
>  EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
>  				     enum mnl_attr_data_type type,
> @@ -249,8 +267,8 @@ EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
>   * usually happens at this stage or you can use any other data structure (such
>   * as lists or trees).
>   *
> - * This function propagates the return value of the callback, which can be
> - * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
> + * \return propagated value from callback, one of MNL_CB_ERROR, MNL_CB_STOP
> + * or MNL_CB_OK
>   */
>  EXPORT_SYMBOL int mnl_attr_parse(const struct nlmsghdr *nlh,
>  				 unsigned int offset, mnl_attr_cb_t cb,
> @@ -276,8 +294,8 @@ EXPORT_SYMBOL int mnl_attr_parse(const struct nlmsghdr *nlh,
>   * usually happens at this stage or you can use any other data structure (such
>   * as lists or trees).
>   *
> - * This function propagates the return value of the callback, which can be
> - * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
> +* \return propagated value from callback, one of MNL_CB_ERROR, MNL_CB_STOP
> +* or MNL_CB_OK
>   */
>  EXPORT_SYMBOL int mnl_attr_parse_nested(const struct nlattr *nested,
>  					mnl_attr_cb_t cb, void *data)
> @@ -307,8 +325,8 @@ EXPORT_SYMBOL int mnl_attr_parse_nested(const struct nlattr *nested,
>   * located at some payload offset. You can then put the attributes in one array
>   * as usual, or you can use any other data structure (such as lists or trees).
>   *
> - * This function propagates the return value of the callback, which can be
> - * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
> + * \return propagated value from callback, one of MNL_CB_ERROR, MNL_CB_STOP
> + * or MNL_CB_OK
>   */
>  EXPORT_SYMBOL int mnl_attr_parse_payload(const void *payload,
>  					 size_t payload_len,
> @@ -324,10 +342,10 @@ EXPORT_SYMBOL int mnl_attr_parse_payload(const void *payload,
>  }
>
>  /**
> - * mnl_attr_get_u8 - returns 8-bit unsigned integer attribute payload
> + * mnl_attr_get_u8 - get 8-bit unsigned integer attribute payload
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the 8-bit value of the attribute payload.
> + * \return 8-bit value of the attribute payload
>   */
>  EXPORT_SYMBOL uint8_t mnl_attr_get_u8(const struct nlattr *attr)
>  {
> @@ -335,10 +353,10 @@ EXPORT_SYMBOL uint8_t mnl_attr_get_u8(const struct nlattr *attr)
>  }
>
>  /**
> - * mnl_attr_get_u16 - returns 16-bit unsigned integer attribute payload
> + * mnl_attr_get_u16 - get 16-bit unsigned integer attribute payload
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the 16-bit value of the attribute payload.
> + * \return 16-bit value of the attribute payload
>   */
>  EXPORT_SYMBOL uint16_t mnl_attr_get_u16(const struct nlattr *attr)
>  {
> @@ -346,10 +364,10 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_u16(const struct nlattr *attr)
>  }
>
>  /**
> - * mnl_attr_get_u32 - returns 32-bit unsigned integer attribute payload
> + * mnl_attr_get_u32 - get 32-bit unsigned integer attribute payload
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the 32-bit value of the attribute payload.
> + * \return 32-bit value of the attribute payload
>   */
>  EXPORT_SYMBOL uint32_t mnl_attr_get_u32(const struct nlattr *attr)
>  {
> @@ -357,12 +375,12 @@ EXPORT_SYMBOL uint32_t mnl_attr_get_u32(const struct nlattr *attr)
>  }
>
>  /**
> - * mnl_attr_get_u64 - returns 64-bit unsigned integer attribute.
> + * mnl_attr_get_u64 - get 64-bit unsigned integer attribute
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the 64-bit value of the attribute payload. This
> - * function is align-safe, since accessing 64-bit Netlink attributes is a
> - * common source of alignment issues.
> + * This function reads the 64-bit nlattr payload in an alignment safe manner.
> + *
> + * \return 64-bit value of the attribute payload
>   */
>  EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
>  {
> @@ -372,10 +390,10 @@ EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
>  }
>
>  /**
> - * mnl_attr_get_str - returns pointer to string attribute.
> + * mnl_attr_get_str - get pointer to string attribute
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the payload of string attribute value.
> + * \return string pointer of the attribute payload
>   */
>  EXPORT_SYMBOL const char *mnl_attr_get_str(const struct nlattr *attr)
>  {
> @@ -508,8 +526,9 @@ EXPORT_SYMBOL void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type,
>   * \param type netlink attribute type
>   *
>   * This function adds the attribute header that identifies the beginning of
> - * an attribute nest. This function always returns a valid pointer to the
> - * beginning of the nest.
> + * an attribute nest.
> + *
> + * \return valid pointer to the beginning of the nest
>   */
>  EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh,
>  						 uint16_t type)
> @@ -534,8 +553,9 @@ EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
>  				      uint16_t type, size_t len,
> @@ -557,8 +577,9 @@ EXPORT_SYMBOL bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
>  					 uint16_t type, uint8_t data)
> @@ -576,10 +597,9 @@ EXPORT_SYMBOL bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> - * This function updates the length field of the Netlink message (nlmsg_len)
> - * by adding the size (header + payload) of the new attribute.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
>  					  uint16_t type, uint16_t data)
> @@ -597,10 +617,9 @@ EXPORT_SYMBOL bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> - * This function updates the length field of the Netlink message (nlmsg_len)
> - * by adding the size (header + payload) of the new attribute.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
>  					  uint16_t type, uint32_t data)
> @@ -618,10 +637,9 @@ EXPORT_SYMBOL bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> - * This function updates the length field of the Netlink message (nlmsg_len)
> - * by adding the size (header + payload) of the new attribute.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
>  					  uint16_t type, uint64_t data)
> @@ -639,10 +657,9 @@ EXPORT_SYMBOL bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> - * This function updates the length field of the Netlink message (nlmsg_len)
> - * by adding the size (header + payload) of the new attribute.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
>  					  uint16_t type, const char *data)
> @@ -663,8 +680,9 @@ EXPORT_SYMBOL bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
>   * This function first checks that the data can be added to the message
>   * (fits into the buffer) and then updates the length field of the Netlink
>   * message (nlmsg_len) by adding the size (header + payload) of the new
> - * attribute. The function returns true if the attribute could be added
> - * to the message, otherwise false is returned.
> + * attribute.
> + *
> + * \return true if the attribute could be added, false otherwise
>   */
>  EXPORT_SYMBOL bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
>  					   uint16_t type, const char *data)
> @@ -679,8 +697,10 @@ EXPORT_SYMBOL bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
>   * \param type netlink attribute type
>   *
>   * This function adds the attribute header that identifies the beginning of
> - * an attribute nest. If the nested attribute cannot be added then NULL,
> - * otherwise valid pointer to the beginning of the nest is returned.
> + * an attribute nest.
> + *
> + * \return NULL if the attribute cannot be added, otherwise a pointer to the
> + * beginning of the nest
>   */
>  EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh,
>  						       size_t buflen,
> --
> 2.37.1.208.ge72d93e88cb2
>
Acked-by: Duncan Roe <duncan_roe@optusnet.com.au>
